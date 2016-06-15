require 'resque'

class FrequentJob
  @queue = :general

  def self.perform
    File.open("job_output.log", "a") do |file|
      file.puts(Time.now.strftime("%H:%M:%S"))
    end
  end
end

if __FILE__ == $0 

  begin
    File.delete("job_output.log")
  rescue
  end

  t_start = Time.now
  duration = 3
  t_end  = t_start + duration
  puts "Running for #{duration}s"

  enqueue_timestamp_bins = {}
  while true  
    ts = Time.now.strftime("%H:%M:%S")
    Resque.enqueue(FrequentJob)
    if enqueue_timestamp_bins[ts].nil?
      enqueue_timestamp_bins[ts] = 1
    else
      enqueue_timestamp_bins[ts] +=1
    end

    if Time.now >= t_end
      break
    end
  end

  puts "Enqueue Counts"
  enqueue_timestamp_bins.sort.map do |k, v|
    puts "#{k} : #{v}"
  end

  total_enqueued = enqueue_timestamp_bins.values.reduce(:+)
  puts "Total enqueued: #{total_enqueued}"

  puts "Waiting for queue to empty..."
  while Resque.size("general") > 0
    next
  end
  puts "Done"
end
