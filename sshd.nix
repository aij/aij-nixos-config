{ ... }: {
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAm/qx6C2ZvSTGlUJXvucKpOs2rx6B1XnJWo0I8IYyCYoQxzjjNEwcLiy7bgOCjfYNqb2z/5XlMuspa0S32sUx0Z3WuJe9g6HOMzpxxaS9iYVW4eXtfpkbXBBkwXrwaFQ/3NX+/12cgj+8hgkkQFFBBUdUcU1UBRrBo9N5MqCSpjkDKFpFObSQ/gAu9Rv0cgQD4nRSvktEkd/43tI0PE+DLW0/xB6DOCN76eAEK9vB+EvPXndzAkaChF+ICmX6CLfSQVHPzujkQrFVVQCIWR2kQgtIFCh28hIp8wRJko3bUyN3oY40fFxAriP70ze3RX2M6GzuH4oN88rGCOW2WT08P/6hcqPZWQQxr7ZlWn/e1dFTH3RJluiitQ3Em7Z1jHfTy/1NWRl2s0+ZEUA1H9uUUvejPUo5J15Vjrepc7RGZ0CWtU2aP+nTTQQfvDizMiVXMNyIoUl8uTJt8zn8loLx82O8qrZ3D+7fbV2mXUlJVmG/aZvlU86dDX8BLU29B1LBFaLd3bJnIoZ/JnTEKXYKs/vZaFiU/IQpw80Ev91P5KkXsxOssIL5VpZ7S4nAUz+0FjPEeQfj0lnjb5a7nFhIFG7K46p95HUrmojJ3+6jzKUHMQdVEefYRKYo/yDK63PF2JMzDnkTO0t4rSeAqXHE47Vv8MrbgWOQ/w4HyZccmMc= aij@ita"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTGD3FImr4dsW6pmGT5muMDjEoOTPMxxvhwWMMyAcpC ivan@tobati"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIORLMYgWkpO8Psfx9cI/kLtgrxo7M4sbgBL/4wNKQDvL ivan@ita"
  ];
}
