import "package:dio/dio.dart";

const token =
    "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2Nsb3VkLmdvb2dsZS5jb20vd29ya3N0YXRpb25zIiwiYXVkIjoiaWR4LWFwaS1hYnNlbnNpLTE3MjIzMTM0NzQwMDguY2x1c3Rlci1hM2dyanplazY1Y3hleDc2MmU0bXdyemw0Ni5jbG91ZHdvcmtzdGF0aW9ucy5kZXYiLCJpYXQiOjE3MjI0NzczMjcsImV4cCI6MTcyMjQ4MDkyN30.qcvSuNMGGthMeJO11W96n_Ir0WnVX3wvgcGZpDvJeqzmXfaLHAwCG3Mx_sI5KI8KOLWWQ3ZNOUytcVPkecO9I0ZD_wrjx6qJBTXc_1G8cTA7KiQ8mXldQkSHDSZ7dGK6AEDJg4J86dnGd5YYuJrUDofzX8R04_eHVUNOx3eD2g_AXFzm3f5G_-0dw5QE42Dqk_C__RRxb9YYhSpLHZwPSsIGnkHSH792pZtQWZcXRmj0k0_KAe_eb8Erpo6CSJi_PHZ4ZVhQLfIUYF9l7OSWd1QhP3SIs0LDTfD2BiTXGknbvQ7noMI3LYxRNpviReB042ZYa2fdKlrQmtynMureDA";

final dio = Dio(BaseOptions(
  baseUrl:
      "https://9000-idx-api-absensi-1722313474008.cluster-a3grjzek65cxex762e4mwrzl46.cloudworkstations.dev/api",
  headers: {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  },
));
