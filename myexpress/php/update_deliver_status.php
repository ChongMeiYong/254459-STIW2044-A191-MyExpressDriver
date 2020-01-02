<?php
error_reporting(0);
include_once("dbconnect.php");
$jobtitle = $_POST['jobtitle'];
$status = $_POST['status'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$sql = "SELECT * FROM JOBS WHERE JOBTITLE = '$jobtitle'";

if (isset($name) && (!empty($name))){
    $sql = "UPDATE JOBS SET STATUS = '$status' WHERE JOBTITLE = '$jobtitle";
}


if ($conn->query($sql) === TRUE) {
    $result = $conn->query($sql);
if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["JOBTITLE"];
        }
    }else{
        echo "failed,null";
    }
} else {
    echo "error";
}

$conn->close();
?>
