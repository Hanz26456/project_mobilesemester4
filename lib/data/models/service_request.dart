class ServiceSearchRequest {
  final String search;

  ServiceSearchRequest({required this.search});

  Map<String, String> toQuery() {
    return {
      'search': search,
    };
  }
}
