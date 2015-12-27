template '/etc/nginx/conf.d/hex7.conf' do
  source 'nginx.conf.erb'
end

service 'nginx' do
  action :restart
end
