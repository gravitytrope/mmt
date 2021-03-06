# :nodoc:
class VariablesController < BasePublishedRecordController
  include ManageMetadataHelper

  before_action :set_variable, only: [:show, :edit, :clone, :destroy, :revisions, :revert, :download_json]
  before_action :set_schema, only: [:show, :edit, :clone, :destroy]
  before_action :set_form, only: [:show, :edit, :clone, :destroy]
  before_action :ensure_supported_version, only: [:show, :edit]
  before_action :ensure_correct_provider, only: [:edit, :clone, :destroy]
  before_action :set_preview, only: [:show]

  # If clone is not defined like this performing the clone action leads to a `action not found error`
  # we looked into this but couldn't find a way around this without having clone call super
  def clone
    super
  end

  private

  def resource_schema_file
    'umm-var-json-schema.json'
  end

  def resource_form_file
    'umm-var-form.json'
  end

  def resource_preview_schema
    'umm-var-preview.json'
  end
end
