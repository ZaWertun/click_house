# frozen_string_literal: true

module ClickHouse
  module Extend
    module ConnectionSelective
      # @return [ResultSet]
      def select_all(sql, params={})
        response = get(body: sql, params: params, query: { default_format: 'JSON' })
        Response::Factory.response(response, config)
      end

      def select_value(sql, params={})
        response = get(body: sql, params: params, query: { default_format: 'JSON' })
        got = Response::Factory.response(response, config).first

        case got
        when Hash
          Array(got).dig(0, -1) # get a value of a first key for JSON format
        when Array
          got[0] # for CSV format
        else
          got # for RowBinary format
        end
      end

      def select_one(sql, params={})
        response = get(body: sql, params: params, query: { default_format: 'JSON' })
        Response::Factory.response(response, config).first
      end
    end
  end
end
