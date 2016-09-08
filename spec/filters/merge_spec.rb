# encoding: utf-8
require 'spec_helper'
require "logstash/filters/merge"

describe LogStash::Filters::Merge do
  describe "minimal config with hash" do
    let(:config) { '''
      filter {
        merge {
          field => "data"
        }
      }
    ''' }

    sample("data" => {"one" => 1, "two" => 2}, "three" => 3) do
      expect(subject.get("one")).to eq(1)
      expect(subject.get("two")).to eq(2)
      expect(subject.get("three")).to eq(3)
    end

    sample("data" => {"one" => 1}, "one" => 0) do
      expect(subject.get("one")).to eq(1)
    end
  end

  describe "minimal config with whitelist" do
    let(:config) { '''
      filter {
        merge {
          field => "data"
          whitelist => ["one"]
        }
      }
    ''' }

    sample("data" => {"one" => 1, "two" => 2}, "three" => 3) do
      expect(subject.get("one")).to eq(1)
      expect(subject.get("two")).to eq(nil)
      expect(subject.get("three")).to eq(3)
    end
  end

  describe "overwrite set to false with hash" do
    let(:config) { '''
      filter {
        merge {
          field => "data"
          overwrite => false
        }
      }
    ''' }

    sample("data" => {"one" => 1, "two" => 2}, "three" => 3) do
      expect(subject.get("one")).to eq(1)
      expect(subject.get("two")).to eq(2)
      expect(subject.get("three")).to eq(3)
    end

    sample("data" => {"one" => 1, "two" => 2}, "one" => 0) do
      expect(subject.get("one")).to eq(0)
      expect(subject.get("two")).to eq(2)
    end
  end

  describe "target set to field with hash" do
    let(:config) { '''
      filter {
        merge {
          field => "data"
          target => "target"
        }
      }
    ''' }

    sample("data" => {"one" => 1, "two" => 2}, "target" => 3) do
      expect(subject.get("target")).to eq({"one" => 1, "two" => 2})
    end

    sample("data" => {"one" => 1, "two" => 2}, "target" => "testing") do
      expect(subject.get("target")).to eq({"one" => 1, "two" => 2})
    end

    sample("data" => {"one" => 1, "two" => 2}, "target" => {"one" => 0, "three" => 3}) do
      expect(subject.get("target")).to eq({"one" => 1, "two" => 2, "three" => 3})
    end
  end

  describe "minimal config with integer" do
    let(:config) { '''
      filter {
        merge {
          field => "data"
          target => "output"
        }
      }
    ''' }

    sample("data" => 1) do
      expect(subject.get("output")).to eq(1)
    end

    sample("data" => 1, "output" => 0) do
      expect(subject.get("output")).to eq(1)
    end
  end

  describe "overwrite set to false with integer" do
    let(:config) { '''
      filter {
        merge {
          field => "data"
          target => "output"
          overwrite => false
        }
      }
    ''' }

    sample("data" => 1) do
      expect(subject.get("output")).to eq(1)
    end

    sample("data" => 1, "output" => 0) do
      expect(subject.get("output")).to eq(0)
    end
  end
end
