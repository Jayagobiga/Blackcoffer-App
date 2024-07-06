<?php
require_once('conn.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $title = $_POST['title'];
    $description = $_POST['description'];
    $category = $_POST['category'];
    $location = $_POST['location'];
    $date_time = $_POST['date_time'];

    // Handle the video file upload
    $target_dir = "uploads/";
    $target_file = $target_dir . basename($_FILES["video"]["name"]);
    $video_path = "";

    if (move_uploaded_file($_FILES["video"]["tmp_name"], $target_file)) {
        $video_path = $target_file;
    } else {
        echo json_encode(["status" => "error", "message" => "Sorry, there was an error uploading your file."]);
        exit();
    }

    $stmt = $conn->prepare("INSERT INTO videos (title, description, category, location, date_time, video_path) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssss", $title, $description, $category, $location, $date_time, $video_path);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Video uploaded successfully."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error: " . $stmt->error]);
    }

    $stmt->close();
}

$conn->close();
?>
