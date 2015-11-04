module Hubspot
  class Workflow
    WORKFLOWS_PATH = "/automation/v3/workflows"
    WORKFLOW_PATH = "/automation/v3/workflows/:workflow_id"
    WORKFLOW_ENROLLMENT_PATH = "/automation/v2/workflows/:workflow_id/enrollments/contacts/:email"

    class << self
      def list
        response = Hubspot::Connection.get_json(WORKFLOWS_PATH, {})
        response['workflows'].map { |w| new(w) }
      end

      def find_by_workflow_id(id, opts = {})
        response = Hubspot::Connection.get_json(WORKFLOW_PATH, opts.merge({ workflow_id: id }))
        new(response)
      end
    end

    attr_reader :id
    attr_reader :name
    attr_reader :enabled
    attr_reader :inserted_at
    attr_reader :updated_at

    def initialize(response_hash)
      @id = response_hash['id']
      @name = response_hash['name']
      @enabled = response_hash['enabled']
      @inserted_at = Time.at(response_hash['insertedAt'] / 1000)
      @updated_at = Time.at(response_hash['updatedAt'] / 1000)
    end

    def enroll_contact_by_email(email)
      response = Hubspot::Connection.post_json(WORKFLOW_ENROLLMENT_PATH, params: { workflow_id: id, email: email})
      self
    end

    def unenroll_contact_by_email(email)
      response = Hubspot::Connection.delete_json(WORKFLOW_ENROLLMENT_PATH, {workflow_id: id, email: email} )
      self
    end
  end
end
