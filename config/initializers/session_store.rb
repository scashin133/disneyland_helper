# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_disneyland_helper_session',
  :secret      => 'eff1284cca4f0bf2044a5bbfbbe21dc8ef7417c74a02d1df1ca115106a134b9aebbebadfd0e7e9e99dab5f2b545cba47afb1e93b78f33ea12148d2cc48a0db4c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
