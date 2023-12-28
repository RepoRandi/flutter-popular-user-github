class User {
  final String? login;
  final int? id;
  final String? node_id;
  final String? avatarUrl;
  final String? gravatar_id;
  final String? url;
  final String? html_url;
  final String? followers_url;
  final String? following_url;
  final String? gists_url;
  final String? starred_url;
  final String? subscriptions_url;
  final String? organizations_url;
  final String? repos_url;
  final String? events_url;
  final String? received_events_url;
  final String? type;
  final bool? site_admin;
  final double? score;

  final String? name;
  final String? email;
  final String? location;
  final String? company;

  User({
    this.login,
    this.id,
    this.node_id,
    this.avatarUrl,
    this.gravatar_id,
    this.url,
    this.html_url,
    this.followers_url,
    this.following_url,
    this.gists_url,
    this.starred_url,
    this.subscriptions_url,
    this.organizations_url,
    this.repos_url,
    this.events_url,
    this.received_events_url,
    this.type,
    this.site_admin,
    this.score,
    this.name,
    this.email,
    this.location,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      id: json['id'],
      node_id: json['node_id'],
      avatarUrl: json['avatar_url'],
      gravatar_id: json['gravatar_id'],
      url: json['url'],
      html_url: json['html_url'],
      followers_url: json['followers_url'],
      following_url: json['following_url'],
      gists_url: json['gists_url'],
      starred_url: json['starred_url'],
      subscriptions_url: json['subscriptions_url'],
      organizations_url: json['organizations_url'],
      repos_url: json['repos_url'],
      events_url: json['events_url'],
      received_events_url: json['received_events_url'],
      type: json['type'],
      site_admin: json['site_admin'],
      score: json['score']?.toDouble() ?? 0.0,
      name: json['name'],
      email: json['email'],
      location: json['location'],
      company: json['company'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'avatarUrl': avatarUrl,
      'name': name,
      'email': email,
      'location': location,
      'company': company,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      login: map['login'],
      avatarUrl: map['avatarUrl'],
      name: map['name'],
      email: map['email'],
      location: map['location'],
      company: map['company'],
    );
  }
}
