module Ldp
  class Resource::RdfSource < Ldp::Resource

    def initialize client, subject, graph_or_response = nil
      super client, subject

      case graph_or_response
        when RDF::Graph
          @graph = graph_or_response
        when Ldp::Response
          @get = graph_or_response if current? graph_or_response
        when NilClass
          #nop
        else
          raise ArgumentError, "Third argument to #{self.class}.new should be a RDF::Graph or a Ldp::Response. You provided #{graph_or_response.class}"
      end
    end

    ##
    # Create a new resource at the URI
    # @return [RdfSource] the new representation
    def create
      raise "Can't call create on an existing resource" unless new?
      resp = client.post client.endpoint_path, graph.dump(:ttl) do |req|
        req.headers['Slug'] = slug if subject
      end

      @subject = resp.headers['Location']
      @subject_uri = nil
      reload
    end

    ##
    # Update the stored graph
    def update new_graph = nil
      new_graph ||= graph
      client.put subject, new_graph.dump(:ttl) do |req|
        req.headers['If-Match'] = get.etag if retrieved_content?
      end
    end

    def graph
      @graph ||= begin
        original_graph = get.graph

        inlinedResources = get.graph.query(:predicate => Ldp.contains).map { |x| x.object }

        # we want to scope this graph to just statements about this model, not contained relations
        unless inlinedResources.empty?
          new_graph = RDF::Graph.new

          original_graph.each_statement do |s|
            unless inlinedResources.include? s.subject
              new_graph << s
            end
          end

          new_graph
        else
          original_graph
        end
      end
    end

    def check_for_differences_and_reload
      self.class.check_for_differences_and_reload_resource self
    end

    def self.check_for_differences_and_reload_resource old_object
      new_object = old_object.reload

      bijection = new_object.graph.bijection_to(old_object.graph)
      diff = RDF::Graph.new

      old_object.graph.each do |statement|
        if statement.has_blank_nodes?
          subject = bijection.fetch(statement.subject, false) if statement.subject.node?
          object = bijection.fetch(statement.object, false) if statement.object.node?
          bijection_statement = RDF::Statement.new :subject => subject || statemnet.subject, :predicate => statement.predicate, :object => object || statement.object

          diff << statement if subject === false or object === false or new_object.graph.has_statement?(bijection_statement)
        elsif !new_object.graph.has_statement? statement
          diff << statement
        end
      end

      diff
    end

    private

      def slug
        subject.sub(/^.+#{client.endpoint_path}\//, '')
      end
  end
end
