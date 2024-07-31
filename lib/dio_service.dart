import "package:dio/dio.dart";

const token =
    "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2Nsb3VkLmdvb2dsZS5jb20vd29ya3N0YXRpb25zIiwiYXVkIjoiaWR4LWFwaS1hYnNlbnNpLTE3MjIzMTM0NzQwMDguY2x1c3Rlci1hM2dyanplazY1Y3hleDc2MmU0bXdyemw0Ni5jbG91ZHdvcmtzdGF0aW9ucy5kZXYiLCJpYXQiOjE3MjIzOTQ5NjEsImV4cCI6MTcyMjM5ODU2MX0.qd1E-bfKzF83cRMmAtf74OnpQ4_RbGrEGXXF2Gaz-ksc8ChowaauyeSlfwqWURDowHCbbluXHZPQWmyBT7J3ISvp51jiJmYFbo8uPBgnpS73lsYC0XsqZgEmUNxPZsMoxdurCl161j-rBGEPJ0oAkHrZrbuK8wPpwTxk8GYpoLl3QvOTaBEbA8WkicCPEgUnlMU6HmcQF2OGt93k67FmaC7hkdszKJcnh4bvgwjevkbolT2KbV3pjTgYZhNSSohhgctriMwgKNpFvMuBBMp7a_iW8pc11GapjJY9Clg1WiWhcTDgOKQVdZSK4VBZkLmyNywWxfxXLbnkEfwFX7KBoA";

final dio = Dio(BaseOptions(
  baseUrl:
      "https://9000-idx-api-absensi-1722313474008.cluster-a3grjzek65cxex762e4mwrzl46.cloudworkstations.dev/api",
  headers: {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  },
));
