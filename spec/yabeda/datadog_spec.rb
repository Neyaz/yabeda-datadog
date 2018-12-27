# frozen_string_literal: true

RSpec.describe Yabeda::DataDog do
  it "has a version number" do
    expect(Yabeda::DataDog::VERSION).not_to be nil
  end

  describe "DataDog API interaction" do
    let(:dogapi_client) { instance_double("Dogapi::Client") }
    let!(:counter)   { Yabeda.counter(:gate_opens) }
    let!(:gauge)     { Yabeda.gauge(:water_level) }
    let!(:histogram) do
      Yabeda.histogram(:gate_throughput, unit: :cubic_meters, per: :gate_open, buckets: [1, 10, 100, 1_000, 10_000])
    end

    before do
      allow(dogapi_client).to receive(:emit_point)
      allow(dogapi_client).to receive(:emit_points)
      allow(Dogapi::Client).to receive(:new).and_return(dogapi_client)
      allow(Time).to receive(:now)
    end

    it "calls increment_metric on counter increment" do
      Yabeda.gate_opens.increment(gate: :fake)
      expect(dogapi_client).to have_received(:emit_point).with("gate_opens", 1, tags: ["gate: fake"], type: "counter")
    end

    it "calls record_metric on gauge change" do
      Yabeda.water_level.set({}, 42)
      expect(dogapi_client).to have_received(:emit_point).with("water_level", 42, tags: [], type: "gauge")
    end

    it "calls record_metric on histogram measure" do
      Yabeda.gate_throughput.measure({ gate: 1 }, 4321)
      expect(dogapi_client).to have_received(:emit_points).with("gate_throughput", [[Time.now, 4321]], tags: ["gate: 1"], type: "gauge")
    end
  end
end