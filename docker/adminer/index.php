<?php
/**
 * Adminer Custom Configuration for PostgreSQL Development
 * 施設予約システム開発用のAdminer設定
 */

function adminer_object() {

    class AdminerSoftware extends Adminer {

        // カスタムCSS読み込み
        function head() {
            echo '<link rel="stylesheet" type="text/css" href="adminer-custom.css">' . "\n";
        }

        // ログイン画面のカスタマイズ
        function login($login, $password) {
            // 開発環境での自動ログイン機能
            if (isset($_ENV['RAILS_ENV']) && $_ENV['RAILS_ENV'] === 'development') {
                return true;
            }
            return parent::login($login, $password);
        }

        // データベース名の表示カスタマイズ
        function name() {
            return '🐘 施設予約システム - PostgreSQL管理';
        }

        // デフォルト接続情報の設定
        function credentials() {
            return array(
                'localhost', // server
                'postgres',  // username
                'password'   // password
            );
        }

        // 使用可能なデータベースの制限
        function databases($flush = true) {
            return array('myapp_development', 'myapp_test');
        }

        // テーブル一覧のカスタマイズ
        function tablesPrint($tables) {
            echo '<div style="margin-bottom: 20px; padding: 15px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px;">';
            echo '<h3 style="color: white; margin: 0; font-size: 1.2em;">📊 施設予約システム テーブル一覧</h3>';
            echo '</div>';

            $core_tables = array();
            $system_tables = array();

            foreach ($tables as $table => $status) {
                if (in_array($table, array('users', 'facilities', 'reservations', 'facility_managers', 'lottery_periods', 'lottery_applications', 'lottery_results'))) {
                    $core_tables[$table] = $status;
                } else {
                    $system_tables[$table] = $status;
                }
            }

            if (!empty($core_tables)) {
                echo '<div style="margin-bottom: 20px;">';
                echo '<h4 style="color: #90cdf4; margin-bottom: 10px;">🏗️ コアテーブル</h4>';
                echo '<table cellspacing="0" style="width: 100%;">';
                foreach ($core_tables as $table => $status) {
                    $icon = $this->getTableIcon($table);
                    echo '<tr>';
                    echo '<td><a href="' . h(ME . "select=" . urlencode($table)) . '">' . $icon . ' ' . h($table) . '</a></td>';
                    echo '<td>' . ($status ? number_format($status) . ' rows' : 'Empty') . '</td>';
                    echo '</tr>';
                }
                echo '</table>';
                echo '</div>';
            }

            if (!empty($system_tables)) {
                echo '<div>';
                echo '<h4 style="color: #cbd5e0; margin-bottom: 10px;">⚙️ システムテーブル</h4>';
                echo '<table cellspacing="0" style="width: 100%;">';
                foreach ($system_tables as $table => $status) {
                    echo '<tr>';
                    echo '<td><a href="' . h(ME . "select=" . urlencode($table)) . '">' . h($table) . '</a></td>';
                    echo '<td>' . ($status ? number_format($status) . ' rows' : 'Empty') . '</td>';
                    echo '</tr>';
                }
                echo '</table>';
                echo '</div>';
            }
        }

        // テーブル別アイコン取得
        function getTableIcon($table) {
            $icons = array(
                'users' => '👥',
                'facilities' => '🏢',
                'reservations' => '📅',
                'facility_managers' => '👨‍💼',
                'lottery_periods' => '🎲',
                'lottery_applications' => '🎟️',
                'lottery_results' => '🏆'
            );

            return isset($icons[$table]) ? $icons[$table] : '📋';
        }

        // SQLクエリのカスタム履歴
        function queryHistory() {
            return array(
                // よく使うクエリの履歴
                "SELECT * FROM users WHERE role = 'system_admin';",
                "SELECT f.name, COUNT(r.id) as reservation_count FROM facilities f LEFT JOIN reservations r ON f.id = r.facility_id GROUP BY f.id, f.name;",
                "SELECT * FROM reservations WHERE status = 'pending' ORDER BY created_at DESC;",
                "SELECT u.email, COUNT(r.id) as total_reservations FROM users u LEFT JOIN reservations r ON u.id = r.user_id GROUP BY u.id, u.email ORDER BY total_reservations DESC;",
                "SELECT * FROM facilities WHERE active = true ORDER BY name;"
            );
        }

        // 行の表示カスタマイズ
        function selectVal($val, $link, $field, $original) {
            // メールアドレスのマスキング（本番環境用）
            if ($field["field"] == "email" && isset($_ENV['RAILS_ENV']) && $_ENV['RAILS_ENV'] !== 'development') {
                return substr($val, 0, 3) . "***" . substr($val, -10);
            }

            // 日時フィールドの見やすい表示
            if (in_array($field["field"], array("created_at", "updated_at", "start_time", "end_time")) && $val) {
                return "<span title='$val'>" . date('Y/m/d H:i', strtotime($val)) . "</span>";
            }

            // ステータスフィールドの色分け
            if ($field["field"] == "status") {
                $colors = array(
                    'pending' => '#fbbf24',
                    'approved' => '#10b981',
                    'rejected' => '#ef4444',
                    'cancelled' => '#6b7280'
                );
                $color = isset($colors[$val]) ? $colors[$val] : '#6b7280';
                return "<span style='color: $color; font-weight: bold;'>$val</span>";
            }

            // ロールフィールドの表示カスタマイズ
            if ($field["field"] == "role") {
                $role_names = array(
                    'general_user' => '👤 一般ユーザー',
                    'facility_manager' => '👨‍💼 施設管理者',
                    'system_admin' => '👑 システム管理者'
                );
                return isset($role_names[$val]) ? $role_names[$val] : $val;
            }

            return parent::selectVal($val, $link, $field, $original);
        }

        // パスワードフィールドの非表示化
        function editInput($table, $field, $attrs, $value) {
            if ($field["field"] == "encrypted_password") {
                return "<input type='password' disabled value='[暗号化済み]' style='background: #4a5568; color: #a0aec0;'>";
            }
            return parent::editInput($table, $field, $attrs, $value);
        }
    }

    return new AdminerSoftware;
}

// プラグインの読み込み
function adminer_settings() {
    return array(
        'lang' => 'ja',  // 日本語化（利用可能な場合）
        'stylesheet' => 'adminer-custom.css'
    );
}

include "./adminer.php";
?>
