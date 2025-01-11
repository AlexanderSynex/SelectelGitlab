def is_invalid_username(username);
    is_invalid = false;
    if User.find_by_username(username);
        is_invalid = true;
    end;
    is_invalid;
end;

users_list = File.read('/tmp/users.txt').split(/\n/);
unique_users = users_list.group_by { |item| item.downcase };

users_creds = {'users' => Array.new};

group_name = 'Devops' + Date.today.cwyear.to_s;

unless Group.find_by_path_or_name(group_name);
    puts 'Creating group';
    group = Group.create;
    group.name = group_name;
    group.path = group.name.downcase;
    group.lfs_enabled = false;
    group.add_owner(User.first);
    group.save!;
end;

group = Group.find_by_path_or_name(group_name);

puts 'Creating users';
unique_users.each do |key, names|;
    names.each_index do |index|;
        name = names[index];
        t_username = name.gsub(/[[:space:]]/, '').downcase;
        username = t_username;
        password = SecureRandom.hex(12);
        if is_invalid_username(username)
            i = 1;
            while not is_invalid_username(username);
                username = t_username + i.to_s;
                i += 1;
            end;
        end;
        user = User.new(username: "rails_rails", email: "rails_rails@devops-spbstu.ru", name: "Rails Rails", password: "enot2001lol", password_confirmation: "enot2001lol", admin: false);

        user = User.new(username: "#{username}", email: "#{username}@devops-spbstu.ru", name: "#{name}", password: "#{password}", password_confirmation: "#{password}", admin: false)
        user.assign_personal_namespace(Organizations::Organization.default_organization)
        user.skip_confirmation! # Use it only if you wish user to be automatically confirmed. If skipped, user receives confirmation e-mail
        user.save!;
        users_creds['users'].append({"#{user.name}" => {'login'=>"#{user.username}", "email"=>"#{user.email}", "password"=>"#{user.password}"}})
        group.add_developer(user)
    end;
end;

File.write("/tmp/users-creds.yaml", users_creds.to_yaml);
