jobs_processed_timestamp_bins = {}
log = File.open("job_output.log", "r")
while (line = log.gets) do
  ts = line.strip
  if jobs_processed_timestamp_bins[ts].nil?
    jobs_processed_timestamp_bins[ts] = 1
  else
    jobs_processed_timestamp_bins[ts] +=1
  end
end
log.close

puts "Jobs Processed Counts"
jobs_processed_timestamp_bins.sort.map do |k, v|
  puts "#{k} : #{v}"
end

total_enqueued = jobs_processed_timestamp_bins.values.reduce(:+)
puts "Total processed: #{total_enqueued}"
