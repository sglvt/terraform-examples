# sg_a

sg_a_ingress_from_self_list = [ "80,80,tcp,Allow HTTP" ]

sg_a_ingress_source_sg_list = []

sg_a_ingress_cidr_list = [ 
    "443,443,tcp,0.0.0.0/0,Allow HTTPS", 
    "22,22,tcp,10.0.32.0/20,Allow SSH"
]

sg_a_egress_source_sg_list = []

sg_a_egress_cidr_list = [ 
    "0,0,-1,0.0.0.0/0,Allow any" 
]

# sg_b

sg_b_ingress_from_self_list = [ "80,80,tcp,Allow HTTP" ]

sg_b_ingress_cidr_list = [ 
    "443,443,tcp,0.0.0.0/0,Allow HTTPS", 
    "22,22,tcp,10.0.32.0/20,Allow SSH"
]