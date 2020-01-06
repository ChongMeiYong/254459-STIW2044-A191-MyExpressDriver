<?php
error_reporting(0);
include_once("dbconnect.php");

$jobid = $_POST['jobid'];
$status = $_POST['status'];

$usersql = "SELECT * FROM JOBS WHERE JOBID = '$jobid'";

if (isset($status) && (!empty($status))){
    $sql = "UPDATE JOBS SET STATUS = '$status' WHERE JOBID = '$jobid'";
}


if ($conn->query($sql) === TRUE) {
    $result = $conn->query($usersql);
if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["JOBID"].",".$row["JOBTITLE"].",".$row["JOBOWNER"].",".$row["JOBSESC"].",".$row["JOBPRICE"].",".$row["JOBTIME"].",".$row["JOBIMAGE"].",".$row["JOBWORKER"]
        .",".$row["LATITUDE"].",".$row["LONGITUDE"].",".$row["RATING"].",".$row["STATUS"];
        }
    }else{
        echo "failed,null,null,null,null,null,null,null,null,null,null,null,null,null";
    }
} else {
    echo "error";
}

$conn->close();
?>
