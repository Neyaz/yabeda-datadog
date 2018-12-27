# frozen_string_literal: true

require "rufus-scheduler"

module Yabeda
  module DataDog
    class Collector
      class << self
        def start_collect!
          scheduler = Rufus::Scheduler.singleton
          scheduler.every ENV['DATADOG_COLLECT_PERIOD'] || '15s' do
            begin
              Yabeda.collectors.each(&:call)
            rescue => e
              $stderr.puts '-' * 80
              $stderr.puts e.message
              $stderr.puts e.stacktrace
              $stderr.puts '-' * 80
            end
          end
          scheduler.join
        end
      end
    end
  end
end