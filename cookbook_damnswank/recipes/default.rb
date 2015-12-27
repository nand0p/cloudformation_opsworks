template '/etc/nginx/conf.d/damnswank.conf' do
  source 'nginx.conf.erb'
end

service 'nginx' do
  action :restart
end
