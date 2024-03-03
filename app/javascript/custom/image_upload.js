import {UPLOAD_IMAGE_SIZE} from "../constains";

document.addEventListener("turbo:load", function () {
    document.addEventListener("change", function (event) {
        let image_upload = document.querySelector("#micropost_image");
        const size_in_megabytes = image_upload.files[0].size / UPLOAD_IMAGE_SIZE / UPLOAD_IMAGE_SIZE;
        if (size_in_megabytes > 5) {
            alert(t("image.upload_image_error_message"));
            image_upload.value = "";
        }
    });
});
