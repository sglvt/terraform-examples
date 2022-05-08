eks_cluster_name = "c1"
eks_version = "1.18"
eks_enabled_cluster_log_types = [
    # "api",
    # "audit",
    # "authenticator",
    # "controllerManager",
    # "scheduler"
]
eks_endpoint_private_access = "false"
eks_endpoint_public_access = "true"
eks_public_access_cidrs = [ "0.0.0.0/0" ]