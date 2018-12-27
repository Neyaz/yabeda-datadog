# frozen_string_literal: true

require "dogapi"
require "yabeda/base_adapter"
require "yaml"

module Yabeda
  module DataDog
    #DataDog adapter. Sends yabeda metrics as custom metrics to DataDog.
    # See https://docs.datadoghq.com/api/?lang=ruby#get-list-of-active-metrics
    class Adapter < BaseAdapter
      def registry
        @registry = Dogapi::Client.new(ENV['DD_API_KEY'])
      end

      def register_counter!(_metric)
        # Do nothing. DataDog don't need to register metrics
      end

      def perform_counter_increment!(counter, tags, increment)
        registry.emit_point(build_name(counter), increment, type: 'counter', tags: build_tags(tags))
      end

      def register_gauge!(_metric)
        # Do nothing. DataDog don't need to register metrics
      end

      def perform_gauge_set!(metric, tags, value)
        registry.emit_point(build_name(metric), value, type: 'gauge', tags: build_tags(tags))
      end

      def register_histogram!(_metric)
        # Do nothing. DataDog don't need to register metrics
      end

      def perform_histogram_measure!(metric, tags, value)
        registry.emit_points(build_name(metric), [[Time.now, value]], type: 'gauge', tags: build_tags(tags))
      end

      private

      def build_name(metric)
        name = metric.name.to_s
        [metric.group&.capitalize, name].compact.join('.')
      end

      # Convert {key: value} to ["key: value"]
      # https://docs.datadoghq.com/api/?lang=ruby#post-timeseries-points 
      def build_tags(tags)
        tags.map{ |key, value| "#{key}: #{value}" }
      end

      Yabeda.register_adapter(:datadog, new)
    end
  end
end
