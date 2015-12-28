git '/var/www/www.damnswank.com' do
  repository 'https://github.com/nand0p/damnswank.git'
  action :sync
end

service 'nginx' do
  action :restart
end

service 'php-fpm' do
  action :restart
end
