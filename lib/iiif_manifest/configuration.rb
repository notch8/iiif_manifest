# frozen_string_literal: true

module IIIFManifest
  ##
  # Handles configuration for the IIIFManifest gem
  #
  # @see IIIFManifest.config
  class Configuration
    DEFAULT_MANIFEST_PROPERTY_TO_RECORD_METHOD_NAME_MAP = {
      summary: :description,
      label: :to_s,
      rights: :rights_statement,
      homepage: :homepage
    }.freeze

    ##
    # @!attribute [w] manifest_property_to_record_method_name_map
    #   @param value [Hash<Symbol, Symbol>]
    #   @return [Hash<Symbol, Symbol>]
    attr_writer :manifest_property_to_record_method_name_map
    # Used to map a record's public method to a manifest property.
    # @see manifest_value_for
    # @see DEFAULT_MANIFEST_PROPERTY_TO_RECORD_METHOD_NAME_MAP DEFAULT_MANIFEST_PROPERTY_TO_RECORD_METHOD_NAME_MAP are the default values
    # @return [Hash<Symbol, Symbol>]
    def manifest_property_to_record_method_name_map
      @manifest_property_to_record_method_name_map ||= DEFAULT_MANIFEST_PROPERTY_TO_RECORD_METHOD_NAME_MAP
    end

    ##
    # @api private
    # @param record [Object] has the value for the :property we want to set
    # @param property [Symbol] IIIF manifest property
    # @return [NilClass] the record does not have a value for the given property
    # @return [#to_s] the record has a value that is "present"
    def manifest_value_for(record, property:)
      method_name = map_property_to_method_name(property: property)
      return nil unless record.respond_to?(method_name)
      record.public_send(method_name)
    end

    private

    def map_property_to_method_name(property:)
      manifest_property_to_record_method_name_map.fetch(property)
    end
  end
end
