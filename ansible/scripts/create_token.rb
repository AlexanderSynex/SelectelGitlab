user = User.first;
token = user.personal_access_tokens.create(scopes: ['create_runner'], name: 'Runner token', expires_at: 1.day.from_now);
token.save!;
