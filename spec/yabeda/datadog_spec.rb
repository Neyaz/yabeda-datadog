# frozen_string_literal: true

RSpec.describe Yabeda::DataDog do
  it "has a version number" do
    expect(Yabeda::DataDog::VERSION).not_to be nil
  end

  describe "DataDog API interaction" do
    let(:dogapi_client) { instance_double("Datadog::Statsd") }
    let!(:counter)   { Yabeda.counter(:gate_opens) }
    let!(:gauge)     { Yabeda.gauge(:water_level) }
    let!(:histogram) do
      Yabeda.histogram(:gate_throughput, unit: :cubic_meters, per: :gate_open, buckets: [1, 10, 100, 1_000, 10_000])
    end

    before do
      allow(dogapi_client).to receive(:increment)
      allow(dogapi_client).to receive(:gauge)
      allow(dogapi_client).to receive(:histogram)
      allow(Datadog::Statsd).to receive(:new).and_return(dogapi_client)
      allow(Time).to receive(:now)
    end

    it "calls increment_metric on counter increment" do
      Yabeda.gate_opens.increment(gate: :fake)
      expect(dogapi_client).to have_received(:increment).with("gate_opens", by: 1, tags: ["gate: fake"])
    end

    it "calls record_metric on gauge change" do
      Yabeda.water_level.set({}, 42)
      expect(dogapi_client).to have_received(:gauge).with("water_level", 42, tags: [])
    end

    it "calls record_metric on histogram measure" do
      Yabeda.gate_throughput.measure({ gate: 1 }, 4321)
      expect(dogapi_client).to have_received(:histogram).with("gate_throughput", 4321, tags: ["gate: 1"])
    end
  end
end