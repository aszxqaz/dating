import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClient = Supabase.instance.client;
final globalUser = supabaseClient.auth.currentUser;
