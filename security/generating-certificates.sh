# Firstly create the Certificate Authority keys with which to create all other keys
# Generate the private key for the CA
openssl genrsa -out ca.key 2048

# Create cerificate signing request for the CA.  Note the name is the 'Kubernetes CA'
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr

# Create the client certificate for the CA, with CA approval (using the ca.csr)
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt


# Now generate all of the client certificates
#
# 1. Admin user
# 2. Kube Scheduler
# 3. Kube Controller Manager
# 4. Kube Poxy


###########
#
# Admin User certificates
#
###########

# Create the private key for the admin
openssl genrsa -out admin.key 2048

# Generate the Certificate signining request (this will be approve by using the CA key above)
# Note that the name is 'kube-admin' the name that used.  The /O defines the group that the
# certificate belongs to.  In this case the certificates are for the privaleged admin user
openssl req -new -key admin.key -subj "/CN=kube-admin/O=system:masters" -out admin.csr

# Generate the public key for the Admin (using request) and sign it with the CA key pair to make it
# a valid certificate in the cluster.  This is the key used by the admin user to connect to the cluster
openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -out admin.crt


###########
#
# Kube Scheduler User certificates
#
###########

# Create the private key for the admin
openssl genrsa -out kube-scheduler.key 2048

# Generate the Certificate signining request (this will be approve by using the CA key above)
# Note that the name is 'kube-scheduler' the name that used.  
openssl req -new -key kube-scheduler.key -subj "/CN=system:kube-scheduler" -out kube-scheduler.csr

# Generate the public key for the kube-scheduler (using request) and sign it with the CA key pair to make it
# a valid certificate in the cluster.
openssl x509 -req -in kube-scheduler.csr -CA ca.crt -CAkey ca.key -out kube-scheduler.crt


###########
#
# Kube Controller Manager User certificates
#
###########

# Create the private key for the admin
openssl genrsa -out kube-controller-manager.key 2048

# Generate the Certificate signining request (this will be approve by using the CA key above)
# Note that the name is 'kube-controller-manager' the name that used.  
openssl req -new -key kube-controller-manager.key -subj "/CN=system:kube-controller-manager" -out kube-controller-manager.csr

# Generate the public key for the kube-controller-manager (using request) and sign it with the CA key pair to make it
# a valid certificate in the cluster.
openssl x509 -req -in kube-controller-manager.csr -CA ca.crt -CAkey ca.key -out kube-controller-manager.crt


###########
#
# Kube Proxy User certificates
#
###########

# Create the private key for the admin
openssl genrsa -out kube-proxy.key 2048

# Generate the Certificate signining request (this will be approve by using the CA key above)
# Note that the name is 'kube-proxy' the name that used.
openssl req -new -key kube-proxy.key -subj "/CN=kube-proxy" -out kube-proxy.csr

# Generate the public key for the kube-proxy (using request) and sign it with the CA key pair to make it
# a valid certificate in the cluster.
openssl x509 -req -in kube-proxy.csr -CA ca.crt -CAkey ca.key -out kube-proxy.crt




###########################################################################################
#
# Create the server side certificates
#
# 1. ETCD Server
# 2. Kube-Api Server
#
#


###########
#
# ETCD Server certificates
#
###########

# Create the private key for the admin
openssl genrsa -out etcd-server.key 2048

# Generate the Certificate signining request (this will be approve by using the CA key above)
# Note that the name is 'etcd-server' the name that used.
openssl req -new -key etcd-server.key -subj "/CN=etcd-server" -out etcd-server.csr

# Generate the public key for the etcd-server (using request) and sign it with the CA key pair to make it
# a valid certificate in the cluster.
openssl x509 -req -in etcd-server.csr -CA ca.crt -CAkey ca.key -out etcd-server.crt


###
# In the case that the ETCD is part of a cluster, then you need to generate keys for each peer in the
# cluster and pass each of public keys for each peer to the etcd server when you start it.
#
###

###########
#
# Kube Api Server certificates
#
###########

# Create the private key for the admin
openssl genrsa -out kube-api-server.key 2048

# Generate the Certificate signining request (this will be approve by using the CA key above)
# Note that the name is 'kube-api-server' the name that used.
# NOTE:  The kube api server goes by a lot of other names e.g., kubernetes, kubernetes.default, kubernetes.default.svc. kuberentes.default.svc.cluster.local
# In order to pass all these names to the key generation you need an openssl.cnf file (see file here)
openssl req -new -key kube-api-server.key -subj "/CN=kube-api-server" -out kube-api-server.csr

# Generate the public key for the kube-api-server (using request) and sign it with the CA key pair to make it
# a valid certificate in the cluster.
openssl x509 -req -in kube-api-server.csr -CA ca.crt -CAkey ca.key -out kube-api-server.crt
