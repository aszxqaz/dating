import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClient = Supabase.instance.client;
// final globalUser = supabaseClient.auth.currentUser;
// final requireUser = supabaseClient.auth.currentUser!;

User? globalUser;
User requireUser = globalUser!;
