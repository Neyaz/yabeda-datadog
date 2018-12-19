# frozen_string_literal: true

RSpec.describe Yabeda::DataDog do
  it "has a version number" do
    expect(Yabeda::DataDog::VERSION).not_to be nil
  end

  describe "DataDog API interaction" do
    let!(:counter)   { Yabeda.counter(:gate_opens) }
    let!(:gauge)     { Yabeda.gauge(:water_level) }
    let!(:histogram) do
      Yabeda.histogram(:gate_throughput, unit: :cubic_meters, per: :gate_open, buckets: [1, 10, 100, 1_000, 10_000])
    end

    it "calls increment_metric on counter increment" do
      expect(Yabeda.gate_opens.increment(gate: :fake)).to be(1)
    end

    it "calls record_metric on gauge change" do
      expect(Yabeda.water_level.set({}, 42)).to be(42)
    end

    it "calls record_metric on histogram measure" do
      expect(Yabeda.gate_throughput.measure({ gate: 1 }, 4321)).to be(4321)
    end
  end
end