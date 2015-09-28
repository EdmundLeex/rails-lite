require 'uri'

# class ::Hash
#   def deep_merge(second)
#     merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
#     self.merge(second, &merger)
#   end
# end

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  #
  # You haven't done routing yet; but assume route params will be
  # passed in as a hash to `Params.new` as below:
  def initialize(req, route_params = {})
    request = [req.query_string, req.body]
    @params = route_params.map { |k, v| { k.to_sym => v.to_i } if (/\d+/).match(v) }.first || {}
    # debugger
    if !request.compact.empty?
      request.compact.each { |r| parse_www_encoded_form(r) }
    end
  end

  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  # this will be useful if we want to `puts params` in the server log
  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    # debugger
    pairs = URI.decode_www_form(www_encoded_form).to_h
    hashes = []

    pairs.each do |key, val|
      keys = parse_key(key)
      hashes << nest_keys(keys, val)
    end

    merged_hash = {}
    hashes.each do |h|
      merged_hash = deep_merge(merged_hash, h)
    end

    @params = deep_merge(@params, merged_hash)
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end

  def nest_keys(keys, val)
    return { keys.first.to_sym => val } if keys.size == 1

    inner_hash = nest_keys(keys.drop(1), val)
    
    { keys.first.to_sym => inner_hash }
  end

  def deep_merge(h1, h2)
    h1.merge(h2) do |key, v1, v2|
      v1.merge(v2)
    end
  end
end
