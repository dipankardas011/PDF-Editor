import redis


r = redis.Redis(host='db', port=6379, db=0)

r.set('foo', 'bar')
value = r.get('foo')
print(value)
