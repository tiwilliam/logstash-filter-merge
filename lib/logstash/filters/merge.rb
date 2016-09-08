# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

class LogStash::Filters::Merge < LogStash::Filters::Base

  config_name "merge"

  # Field to read from.
  config :field, :validate => :string, :required => true

  # Field to merge with.
  config :target, :validate => :string

  # Overwrite target fields with source field.
  config :overwrite, :validate => :boolean, :default => true

  # Allows you to select which keys to merge from a hash.
  config :whitelist, :validate => :array, :default => []

  private
  def hash_merge(target, source)
    if source.is_a? Hash
      if not target.is_a? Hash and @overwrite
        target = {}
      end

      source.each do |source_key, source_value|
        next if @whitelist.length > 0 and not @whitelist.include? source_key
        next if target.include? source_key and not @overwrite

        target[source_key] = source_value
      end
    else
      if target.nil? or @overwrite
        target = source
      end
    end

    return target
  end

  public
  def register
  end

  public
  def filter(event)
    value = event.get(@field)

    if @target.nil?
      hash_merge(event.to_hash, value)
    else
      event.set(@target, hash_merge(event.get(@target), value))
    end

    filter_matched(event)
  end
end
