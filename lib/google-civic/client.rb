require "erb"
include ERB::Util

require 'google-civic/connection'
require 'google-civic/request'

module GoogleCivic
  class Client
    def initialize(options={})
      @key = options[:key]
    end

    include GoogleCivic::Connection
    include GoogleCivic::Request

    # Gets a list of elections in the API
    #
    # @return [Hashie::Mash] A list of current elections in the API
    # @see https://developers.google.com/civic-information/docs/us_v1/elections/electionQuery
    # @example List the current elections
    #   GoogleCivic.elections
    def elections(options={})
      get("elections", options)
    end

    # Looks up information relevant to a voter based on the voter's registered address.
    #
    # @param election_id [Integer] The id of the election found in .elections
    # @param address [String] The address to search on.
    # @param options [Hash] A customizable set of options.
    # @return [Hashie::Mash] A list of current information around the voter
    # @see https://developers.google.com/civic-information/docs/us_v1/elections/voterInfoQuery
    # @example List information around the voter
    #   GoogleCivic.voter_info(200, '1263 Pacific Ave. Kansas City KS')
    def voter_info(election_id, address, options={})
      get("voterinfo", options.merge({electionId: election_id, address: address}))
    end

    # Looks up political geography and (optionally) representative information based on an address
    #
    # @param address [String] The address to search on.
    # @param options [Hash] A customizable set of options.
    # @return [Hashie::Mash] A list of current information about representatives
    # @see https://developers.google.com/civic-information/docs/v2/representatives/representativeInfoByAddress
    # @example List information about the representatives
    #   GoogleCivic.representative_info('1263 Pacific Ave. Kansas City KS')
    def representative_info_by_address(address, options={})
      get("representatives", options.merge({address: address}))
    end

    # Looks up political geography and (optionally) representative information based on an ocdId
    #
    # @param ocdId [String] The ocdId to search with.
    # @param options [Hash] A customizable set of options.
    # @return [Hashie::Mash] A list of current information about representatives
    # @see https://developers.google.com/civic-information/docs/v2/representatives/representativeInfoByDivision
    # @example List information about the representatives
    #   GoogleCivic.representative_info('ocd-division/country:us/state:nc/county:durham')
    def representative_info_by_division(ocd_id, options={})
      get("representatives/#{url_encode(ocd_id)}", options.merge({}))
    end
  end
end
