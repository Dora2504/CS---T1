# --- Cognito User Pool ---
resource "aws_cognito_user_pool" "user_pool" {
  name = "cs-user-pool"

  # Configurações de senha
  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }

  auto_verified_attributes = ["email"]  # verifica e-mail automaticamente
  mfa_configuration = "OFF"             # MFA desligado
}

# --- App Client (para gerar tokens JWT) ---
resource "aws_cognito_user_pool_client" "app_client" {
  name         = "cs-app-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false  # apenas frontend, sem client secret

  # OAuth 2.0 Authorization Code Flow
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["openid", "email", "profile"]
  allowed_oauth_flows_user_pool_client = true

  # URLs de redirecionamento após login/logout
  callback_urls = ["https://app.corsite.com/callback"]  # ajuste para sua aplicação
  logout_urls   = ["https://app.corsite.com/logout"]
}

# --- Domain para login via Hosted UI ---
resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "cs-demo-auth"  # personalize se quiser
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
