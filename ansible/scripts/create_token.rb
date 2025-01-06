user = User.find_by_username('root');
token = user.personal_access_tokens.create(scopes: [:api], name: 'Automation token', expires_at: Date.tomorrow);
token.save!;
