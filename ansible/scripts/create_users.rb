def generate_random_password(length = 12);
    # Define the character set for the password
    lowercase = ('a'..'z').to_a;
    uppercase = ('A'..'Z').to_a;
    digits = ('0'..'9').to_a;
    special_characters = ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+'];
    all_characters = lowercase + uppercase + digits + special_characters;
    password = Array.new(length) { all_characters.sample }.join;
    password;
end;


students_list = File.read('/tmp/students.txt').split(/\n/);
unique_students = students_list.group_by { |item| item.downcase };

users_creds = {'users' => Array.new}

unique_students.each do |key, names|;
    names.each_index do |index|;
        name = names[index];
        username = name.gsub(/[[:space:]]/, '').downcase;
        if index > 0;
            username += '-' + index.to_s;
        end;
        user = User.create();
        user.name = name;
        user.username = username;
        user.password = generate_random_password(14);
        user.confirmed_at = '01/01/1961';
        user.namespace = Namespace.first;
        user.admin = false;
        user.email = "#{username}@devops-spbstu.ru";
        users_creds['users'].append({"#{user.name}" => {'login'=>"#{user.username}", "password"=>"#{user.password}"}})
        user.save!;
    end;
end;

File.write("/tmp/user-creds.yaml", users_creds.to_yaml);
