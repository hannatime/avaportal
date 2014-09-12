class AvamarApi < ActiveRecord::Base
 
username='admin'
password='password'
authheader='X-Concerto-Authorization'
enc = Base64.encode64(username+":"+password)
print "Encoded Password : "+enc
aveurl = 'https://ave71.lab.local:8543'
loginurl='https://ave71.lab.local:8543/rest-api/login'
versionurl='https://ave71.lab.local:8543/rest-api/versions'
data = RestClient.post loginurl,nil, { 'Content-type'=>'Application/json','Accept'=>'Application/json','Authorization' => "Basic "+enc }
print "Response : "+data
authvalue=data.headers[:'x_concerto_authorization']

accesspoint = JSON.parse(data, :symbolize_names =>true)

accesspointhash = accesspoint[:'accessPoint']
accesspointhash = accesspointhash[0]


providerHref = accesspointhash[:'href']
print "\n provider href : #{providerHref}"

print "\nX-Concerto-Authorization : "+authvalue+"\n"
#print "====== Making Get call to fetch Version information =======\n"
versiondata = RestClient.get versionurl,{ 'Content-type'=>'Application/json','Accept'=>'Application/json',authheader => authvalue}
#print "Response" + data

versionhash = JSON.parse(versiondata,  :symbolize_names =>true)

keys = versionhash.keys
print "\nprovider keys: "+keys.to_s

param = :'entryPoint'
entrypoint = versionhash[param]

entrypoint = entrypoint[0]

apiVersion = :'apiVersion'
#data.default = "MISSING"
versionhash.default = "MISSING"
test = versionhash.has_key?(:'type')


#print versionhash

puts "\n #{entrypoint[:'fullName']} Verison #{entrypoint[apiVersion]} \n"


#versionkeys = versionkeys.keys

#print versionkeys
@Providerhref = accesspoint[:'accessPoint']
@Providerhref = @Providerhref[0]
@Providerhref = @Providerhref[:'href']
@ResourcePools = @Providerhref+"/resourcePool"

@ProviderKeys = RestClient.get @Providerhref,{ 'Content-type'=>'Application/json','Accept'=>'Application/json',authheader => authvalue}

@ProviderJSON = JSON.parse(@ProviderKeys,:symbolize_names =>true )

print "\n"+@ProviderJSON.to_s

@Tenants = @ProviderJSON.keys

print "\nKeys: "+@Tenants.to_s

print "\nTenants: "+@ProviderJSON[:'tenant'].to_s

@ProviderJSON[:'tenant'].each do |d|
  print "\n tenant1: "+d[:'name']
end

@ResourcePoolsJSON = RestClient.get @ResourcePools,{ 'Content-type'=>'Application/json','Accept'=>'Application/json',authheader => authvalue}
@ResourcePoolsHash = JSON.parse(@ResourcePoolsJSON,:symbolize_names =>true )

#print "\n"+@ResourcePoolsHash+"\n"

@resourcePoolDetails = @ResourcePoolsHash[:'resourcePool']
@resourcePoolDetails = @resourcePoolDetails[0]
print "\n"+@resourcePoolDetails.to_s

@poolName = @resourcePoolDetails[:'name']
@poolHref =  @resourcePoolDetails[:'href']
print "\n"+@poolName+"\n"
print "\n"+@poolHref+"\n"

DPResourcesJson = RestClient.get @poolHref,{ 'Content-type'=>'Application/json','Accept'=>'Application/json',authheader => authvalue}
@DPResourcesHash = JSON.parse(DPResourcesJson,:symbolize_names =>true )

@DPResourcesDetails = @DPResourcesHash[:'dataProtectionResource']
@DPResourcesDetails = @DPResourcesDetails[0]

AvamarInstanceName = @DPResourcesDetails[:'name']
ResourcePoolCapacity = @DPResourcesHash[:'capacityInMB']
ResourcePoolUsed = @DPResourcesHash[:'usedInMB']

print "\n Resource Pool: "+@poolName+" Contains the following Avamar Instances: "+AvamarInstanceName
print "\n The pool has: #{ResourcePoolCapacity} MB of capacity of which #{ResourcePoolUsed} MB is Used"

end
