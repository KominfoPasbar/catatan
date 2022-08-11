# CREATE PROCEDURE

```
## PROCEDURE PS_ABSEN_MASUK
CREATE PROCEDURE SP_ABSEN_MASUK(
	IN tgl_sekarang date,
	IN id_user int,
    IN id_admin_instansi int,
    IN username VARCHAR(30),
    IN nama_lengkap VARCHAR(100),
    IN instansi VARCHAR(100),
    IN SSID VARCHAR(100),
    IN BSSID VARCHAR(100),
    OUT output INT 
) 
BEGIN
	SET @eventIDOut = NULL;
	IF EXISTS(SELECT `id_user`, `tgl_absen` FROM `absen5` WHERE `tgl_absen`=@tgl_sekarang and `id_user`=@id_user) THEN
    INSERT INTO absen5 (`id_user`,`id_admin_instansi`,`username`,`nama_lengkap`,`instansi`,`SSID`,`BSSID`,`ip_address`,`tgl_absen`,`file`,`keterangan`,`status`) VALUES (@p1,@p2,@p3,@p4,@p5,@p6,@p7,'',@p0,'','',1);
    SET @eventIDOut = last_insert_id();
    SET output = true;
    ELSE
    SET output = false;
    END IF; 
END
```
