class UserDetails {
  String? fname;
  String? lname;
  String? mobile;
  String? email;
  String? password;
  String? confirmPassword;

  UserDetails(
      {this.fname,
      this.lname,
      this.mobile,
      this.email,
      this.password,
      this.confirmPassword});

  UserDetails.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    lname = json['lname'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['ConfirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['password'] = this.password;
    data['ConfirmPassword'] = this.confirmPassword;
    return data;
  }
}
