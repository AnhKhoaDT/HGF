package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

const (
	// Thay bằng thông tin bạn đã lấy ở Bước 1 & 2
	AWSRegion       = "ap-northeast-2"
	AccessKeyID     = "AKIA254645UC3CR6UHKQLVHEI"
	SecretAccessKey = "45645645"
	BucketName      = "travel-app-dev-123125345634"
)

func main() {
	ctx := context.Background()

	// 1. Khởi tạo cấu hình và S3 Client
	cfg, err := config.LoadDefaultConfig(ctx,
		config.WithRegion(AWSRegion),
		config.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(AccessKeyID, SecretAccessKey, "")),
	)
	if err != nil {
		log.Fatalf("Không thể khởi tạo AWS config: %v", err)
	}

	client := s3.NewFromConfig(cfg)

	// Thông tin file cần tải lên
	filePath := "./matrc.jpg"
	objectKey := "media-dev/matrc123123.jpg" // Đường dẫn thư mục ảo trên S3

	// 2. Upload file lên S3
	_, err = uploadToS3(ctx, client, BucketName, objectKey, filePath)
	if err != nil {
		log.Fatalf("Upload thất bại: %v", err)
	}
	fmt.Println("✅ Đã upload thành công lên AWS S3!")

	// 3. TẠO URL TĨNH ĐỂ LƯU DATABASE
	// Định dạng chuẩn của AWS: https://{bucket-name}.s3.{region}.amazonaws.com/{object-key}
	staticURL := fmt.Sprintf("https://%s.s3.%s.amazonaws.com/%s", BucketName, AWSRegion, objectKey)

	fmt.Println("=== URL ĐỂ LƯU DATABASE ===")
	fmt.Println(staticURL)
}

// Hàm upload file đã nâng cấp
func uploadToS3(ctx context.Context, client *s3.Client, bucket, key, filePath string) (*s3.PutObjectOutput, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	// --- BƯỚC 1: NHẬN DIỆN LOẠI FILE (CONTENT-TYPE) ---
	// Đọc 512 byte đầu tiên của file để xác định định dạng
	buffer := make([]byte, 512)
	_, err = file.Read(buffer)
	if err != nil && err.Error() != "EOF" {
		return nil, err
	}

	// Khôi phục con trỏ đọc file về vị trí ban đầu (số 0) sau khi đã đọc thử
	_, err = file.Seek(0, 0)
	if err != nil {
		return nil, err
	}

	// Tự động phân tích buffer để lấy loại file (VD: "image/jpeg", "image/png")
	contentType := http.DetectContentType(buffer)
	// -------------------------------------------------

	// BƯỚC 2: GỌI API UPLOAD KÈM METADATA
	resp, err := client.PutObject(ctx, &s3.PutObjectInput{
		Bucket:             aws.String(bucket),
		Key:                aws.String(key),
		Body:               file,
		ContentType:        aws.String(contentType), // Khai báo định dạng file
		ContentDisposition: aws.String("inline"),    // Báo cho trình duyệt: HIỂN THỊ, KHÔNG TẢI VỀ
	})

	return resp, err
}
