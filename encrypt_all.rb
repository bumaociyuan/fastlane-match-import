#!/usr/bin/env ruby

origins_path = "origins"

TYPES = ["development", "distribution", "enterprise", "appstore", "adhoc"]
password = ENV['MATCH_PASSWORD']
if password == nil
  puts "Input your decrypt password:"
  password = gets
end

PASSWORD = password

def iterate(source_path, ext)
  Dir[File.join(source_path, "**", "*.#{ext}")].each do |path|
    next if File.directory?(path)
    yield(path)
  end
end

def en_cert(path)
  name = File.basename(path)
  base_path = path.gsub(name,"")
  cert_id = File.basename(path, ".*")
  out_path = base_path.gsub("origins/", "")
  `mkdir -p #{out_path}`
  `openssl pkcs12 -nocerts -nodes -out #{out_path}key.pem -in #{base_path}#{cert_id}.p12`
  `openssl aes-256-cbc -k "#{PASSWORD}" -in #{out_path}key.pem -out #{out_path}#{cert_id}.p12 -a`
  `openssl aes-256-cbc -k "#{PASSWORD}" -in #{base_path}#{cert_id}.cer -out #{out_path}#{cert_id}.cer -a`
  `rm #{out_path}key.pem`
end

def en_profile(path)

  name = File.basename(path)
  base_path = path.gsub(name,"")
  file = path
  bundle_id = File.basename(path, ".*")
  prefixs = ["Development", "Distribution", "InHouse", "AppStore", "AdHoc"]
  prefix = ""
  for i in 0..TYPES.count
    if path.include? TYPES[i]
      prefix = prefixs[i]
      break
    end
  end

  out_path = base_path.gsub("origins/", "")
  `mkdir -p #{out_path}`
  `openssl aes-256-cbc -k "#{PASSWORD}" -in #{file} -out #{out_path}#{prefix}_#{bundle_id}.mobileprovision -a`

end

certs_path = origins_path + "/certs/"
iterate(certs_path, "p12") do |path|
  en_cert(path)
end

mps_path = origins_path + "/profiles/"
iterate(mps_path, "mobileprovision") do |path|
  en_profile(path)
end
