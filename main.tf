provider "aws" {
  region = "us-east-1"
  access_key = "give your access key"
  secret_key = "give your secret key"
}

provider "vault" {
  address = "http://54.159.62.233:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = " give your generated role-id"
      secret_id = "give your generated secret key"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "secret" // change it according to your mount
  name  = "first-secret" // change it according to your secret
}
 


resource "aws_instance" "my_instance" {
  ami           = "your ami id"
  instance_type = "t2.micro"

  tags = {
    
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}