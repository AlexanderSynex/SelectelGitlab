users_list = File.read('/tmp/users.txt').split(/\n/);
unique_users = users_list.group_by { |item| item.downcase };

users_creds = {'users' => Array.new}

unique_users.each do |key, names|;
    names.each_index do |index|;
        name = names[index];
        username = name.gsub(/[[:space:]]/, '').downcase;
        if index > 0;
            username += '-' + index.to_s;
        end;
        user = User.create();
        user.name = name;
        user.username = username;
        user.password = SecureRandom.hex(16);
        user.confirmed_at = '01/01/1961';
        user.namespace = Namespace.first;
        user.admin = false;
        user.email = "#{username}@devops-spbstu.ru";
        users_creds['users'].append({"#{user.name}" => {'login'=>"#{user.username}", "email"=>"#{user.email}" "password"=>"#{user.password}"}})
        user.save!;
    end;
end;

File.write("/tmp/users-creds.yaml", users_creds.to_yaml);
