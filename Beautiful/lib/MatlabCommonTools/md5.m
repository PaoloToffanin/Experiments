function md = md5(msg)

MD = java.security.MessageDigest.getInstance('md5');
md = typecast(MD.digest(uint8(msg)), 'uint8');
md = lower(reshape(dec2hex(md)', 1, []));
