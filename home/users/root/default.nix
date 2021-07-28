{ self, ... }:
# recommend using `hashedPassword`
{
  users.users.root.hashedPassword = "$6$/EKcx40us$Yie88sBDSjknAXCTNSvegcu7vwez2Oe0f7kFz4V6IK1/Twfv6X3Wluuy4rGdj.ZsjtEc54Ts9JCJx4BSc2zCr0";
  age.secrets.root.file = "${self}/secrets/root.age";
  users.users.root.passwordFile = "/run/secrets/root";
}
