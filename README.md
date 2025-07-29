# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Development Login Bypass

For development convenience, magic link authentication can be bypassed:

### Quick Login Options:
1. **Development Navigation Bar**: When not logged in, yellow development bar appears with quick login buttons
2. **Login Form Bypass**: Check "Development Bypass" checkbox on login form to skip email verification
3. **Direct URLs**:
   - `/login/dev_login` - Login as dev@shepherdscollege.edu
   - `/login/dev_login?email=admin@shepherdscollege.edu` - Login as admin@shepherdscollege.edu

### Configuration:
- `config.skip_magic_link_emails = true` in `config/environments/development.rb` (default: true)
- Email validation is relaxed in development (doesn't require @shepherdscollege.edu domain)
- Development users are auto-created during `rails db:seed`

### Security Note:
These bypasses only work in `Rails.env.development?` and are automatically disabled in production.

## Admin User Management

The application includes admin user management functionality:

### Admin Features:
- **User Management Panel**: Admin users can access `/users` to view all users
- **Create New Users**: Admins can add new users by email address from the management panel
- **Admin Privileges**: Admins can grant or revoke admin status for other users
- **Delete Users**: Admins can permanently delete user accounts (except their own)
- **Admin Navigation**: Admin-only "Users" link appears in navigation
- **Self-Protection**: Users cannot modify or delete their own account

### Default Admin Setup:
- Run `rails db:seed` to create development users
- `admin@shepherdscollege.edu` is automatically created with admin privileges
- Use development login bypass to sign in as admin
- Navigate to "Users" in the top navigation to manage other users

### Admin Security:
- Admin access is controlled by `is_admin` boolean field on User model
- All admin actions require `Current.user&.admin?` verification
- Admin status is visually indicated in user lists and navigation

* Dev Setup environment
I run the Windows 11 using WSL2 Unbuntu but most of these instruction should translate to other Dev environments

Use these instruction for the basic Windows setup:
https://gorails.com/setup/windows/11

You can skip the PostgreSQL setup, since we'll be using SQLite for both Dev and Produciton

* Mailcatcher
I also using Mailcatcher for local dev to test outgoing emails.

I found I need to first run:
    ``sudo apt install pkg-config``

Then run:
    ``gem install mailcatcher``

+ Tailwind install
https://tailwindcss.com/docs/installation/framework-guides/ruby-on-rails
``./bin/rails tailwindcss:install``




* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
Currently using Fly.IO

- install Command line tools within WSL: [https://fly.io/docs/flyctl/install/]
  ``curl -L https://fly.io/install.sh | ``

