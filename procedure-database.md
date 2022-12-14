# CREATE PROCEDURE

### PROCEDURE PS_ABSEN_MASUK
```
DELIMITER $$

CREATE PROCEDURE SP_ABSEN_MASUK(
    IN p_tgl_sekarang date,
    IN p_id_user int,
    IN p_id_admin_instansi int,
    IN p_username VARCHAR(30),
    IN p_nama_lengkap VARCHAR(100),
    IN p_instansi VARCHAR(100),
    IN p_SSID VARCHAR(100),
    IN p_BSSID VARCHAR(100),
    OUT output INT 
) 
BEGIN
        IF EXISTS(
        SELECT
            `id_user`,
            `tgl_absen`
        FROM
            `absen5`
        WHERE
            `tgl_absen`=p_tgl_sekarang  AND `id_user`= p_id_user
    ) THEN
SET
    output = FALSE ; 
    ELSE
    INSERT INTO absen5(
    `id_user`,
    `id_admin_instansi`,
    `username`,
    `nama_lengkap`,
    `instansi`,
    `SSID`,
    `BSSID`,
    `ip_address`,
    `tgl_absen`,
    `file`,
    `keterangan`,
    `status`
)
VALUES(p_id_user,p_id_admin_instansi, p_username, p_nama_lengkap, p_instansi, p_SSID, p_BSSID, '', @p0, '', '', 1) ;
SET
    output = TRUE;
    END IF ; 
    END$$
DELIMITER ;
```

### PROCEDURE PS_ABSEN_PULANG
```
CREATE PROCEDURE SP_ABSEN_PULANG(
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
END$$
DELIMITER ;
```


### PROCEDURE PS_AUTH
```
DELIMITER
    $$
CREATE PROCEDURE PS_AUTH(
    IN p_tgl_sekarang DATE,
    IN p_id_user INT,
    IN p_device_id INT,
    IN p_username VARCHAR(100),
    IN p_versi_app VARCHAR(100),
    OUT output INT
)
BEGIN
    SET
        output = NULL ; IF EXISTS(
        SELECT
            `id_user`
        FROM
            auth
        WHERE
            `id_user` = p_id_user
    ) THEN
SET
    output = FALSE ; ELSE
SET
    output = TRUE ;
INSERT INTO auth(
    `id_user`,
    `device_id`,
    `username`,
    `versi_app`,
    `timestamp`
)
VALUES(
    p_id_user,
    p_device_id,
    p_username,
    p_versi_app,
    CURRENT_TIMESTAMP
) ;
END IF ;
END
DELIMITER
    ;
```

## PS_RIWAYAT

### SQL QUERY
```
SELECT id_user,timestamp_masuk,timestamp_pulang,status,tgl_absen,status_approval from absen5 WHERE  EXISTS (SELECT id_user,timestamp,status_approval,tgl_pengajuan FROM approval_ijin 
WHERE date(approval_ijin.timestamp) = date(absen5.timestamp_masuk)  and approval_ijin.status_approval = '2' and approval_ijin.tgl_pengajuan = absen5.tgl_group 
and  approval_ijin.id_user = absen5.id_user and absen5.id_user='6327'  and MONTH(absen5.tgl_absen)= MONTH(NOW())) or ( absen5.id_user = '6327' and absen5.status='1'  and absen5.status_approval <> '2' and MONTH(absen5.tgl_absen)= MONTH(NOW())) 
order by tgl_absen ASC FOR UPDATE
```

### PROSEDURE Riwayat
```
DELIMITER
    $$
CREATE PROCEDURE PS_RIWAYAT(
    IN p_tgl_sekarang DATE,
    IN p_id_user INT,
    IN p_device_id INT,
    IN p_username VARCHAR(100),
    IN p_versi_app VARCHAR(100),
    OUT output INT
)
BEGIN
    SET
        output = NULL ; IF EXISTS(
        SELECT
            *
        FROM
            absen5
        WHERE
            EXISTS(
            SELECT
                *
            FROM
                approval_ijin
            WHERE
                DATE(absen5.timestamp_masuk) = DATE(approval_ijin.timestamp) AND approval_ijin.status_approval = '1'
        ) OR absen5.status = '1' AND approval_ijin.id_user = p_id_user
    ORDER BY
        tgl_absen ASC FOR UPDATE
    ) THEN
SET
    output = FALSE ; ELSE
SET
    output = TRUE ;
INSERT INTO auth(
    `id_user`,
    `device_id`,
    `username`,
    `versi_app`,
    `timestamp`
)
VALUES(
    p_id_user,
    p_device_id,
    p_username,
    p_versi_app,
    CURRENT_TIMESTAMP
) ;
END IF ;
END
DELIMITER
    ;
```



