terraform {
  backend "s3" {
    bucket         = "wu-terraform"   
    key            = "terraform/state.tfstate" 
    region         = "us-west-2"
    encrypt        = true
  }
}
