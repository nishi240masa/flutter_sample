# Flutterサンプルアプリ

## アプリ概要

メモ帳アプリを作成してみました。FreezedやRiverpod等の、制御機構の構成において必要なパッケージを導入し、その他ルーティングや永続化(端末保存)等の機能を実装しています。よければこれをベースに、+αなアプリを自由に創作していただけたらと思います。FirebaseやDio等を使って、ECやSNSのような分散システムを作ってみても良いですし、File Picker等を活用して、漫画アプリにあるビューワーや音楽再生アプリを作ってみても面白いと思います。

## 実行環境について

Flutterについて、以下のバージョンであることを確認してください。  
<pre>
flutter --version
# Flutter 3.10.3 • channel stable • https://github.com/flutter/flutter.git
# Tools • Dart 3.0.3 • DevTools 2.23.1
</pre>
特にこのバージョンでなくても動作が可能であれば問題ありませんが、使用するIDEやパッケージのバージョン次第では非対応、あるいはコンフリクトを起こす可能性があります。

Flutterは基本的に、安定版の中では最新バージョンに整備した方が良いとされる開発ツールです。XcodeやAndroid Studio等のIDEも、バージョンを更新していない場合はここで更新しておきましょう。Flutterのバージョンアップをしたい場合は、以下のコマンドです。
<pre>
flutter upgrade
</pre>
ここでついでにflutter doctorを通じて、接続されているIDEを確認することもできます。目的のプラットフォームでの実行環境にチェックの項目が入っていなかった場合は、お手数おかけしますが、各自で設定していただけたらと思います。

パッケージのバージョンも上げたい場合は、以下のコマンドより。
<pre>
flutter pub upgrade
</pre>

各パッケージの導入について、以下のコマンドを実行してください。  
<pre>
flutter pub get
</pre>

実行するデバイスが認識されていることを確認してください。
<pre>
flutter devices
</pre>

問題が無ければ、実行コマンドを試してみましょう。
<pre>
flutter pub run build_runner build
flutter run
</pre>

また、初心者向けのDartのチュートリアルにつきましては、以下のコマンドより動作確認を通じて、機能を理解していただけたらと存じます。
<pre>
cd lib/dart_tutorial
dart (実行したいファイル名).dart
</pre>


## ソフトウェアアーキテクチャについて

階層化アーキテクチャ、あるいはMVCやMVVM等で見かけるものを参考にし、それに多少オニオンアーキテクチャやクリーンアーキテクチャで見かけるような構成も導入してみました。今回のディレクトリ構成に当てはめるなら、以下のような対応関係であることが汲み取れます。

- freezed_entities: データの定義
- repositories: ビジネスロジックの構築
- providers: アプリケーション固有のロジック(ユースケース)及び制御
- widgets: UIとしての表現

まずはデータを定義し、一まとまりになってる操作や各ユースケースに共通するロジックをrepositories層にとりまとめ、それを基に、providers層でユースケースを生やしていきながら変数の状態を制御する仕組みを書きます。最終的にはそのproviders層で書かれたNotifier及びProviderをUIとして表現できるようにデザインしていきます。

長々とした一文で申し訳ありませんが、依存関係としてはこのようになっております。概要だけでもふわっと掴んでいただければ幸いですし、詳しいことはコードを確認していただいた方が早いかと存じます。

このメモ帳アプリ自身は中規模程度のシステムを想定して作っておりますので、機能要件が膨れ上がっていくにつれ、この仕組みでは適切な責任範囲で作業分担することができない可能性があります。その場合は、より厳密なオニオンアーキテクチャやクリーンアーキテクチャ等で、より大規模システムに使われるアーキテクチャを検討することをオススメします。ただし、その場合は上記で挙げられているパッケージの機能面を損なわないよう、注意が必要です。

プログラミングの技術レベルについては、オブジェクト指向及び関数型プログラミングの知識、またはそれを基盤としたソフトウェアアーキテクチャの理解を前提としておりますので、JavaやC#を用いたオブジェクト指向プログラミング、JavaScriptやTypeScriptを活用したReactやNext.js、LaravelやDjango等のMVCやMVTモデルを活用したバックエンド開発等に携わっていると、より理解が早く進むのではないかと考えています。しかし、Dartのチュートリアルも含め、初心者の方々にもある程度Flutterによるシステム開発の全体像を掴んでいただけるような作り方を意識したつもりですので、無論至らぬ点はあるかと存じますが、見て真似をするだけでも有意義な学習になるのではないかと考えています。

## 初心者向けのDartの勉強について

残念ながら、オブジェクト指向や関数型の詳細につきましては、説明する内容が非常に多くなってしまうため、今回作成したFlutterアプリのアーキテクチャから感覚的に理解を掴んでいただく形になってしまいます。しかし、それ以外の基本的な制御構造やI/Oにつきましては、サンプルとしていくらかコードを提供させていただきました。

これを基に、自分で何かしらのアルゴリズムの問題を作成して解いてみるのも面白いかもしれません。

## コードの読み方について（dart_tutorial以外）

基本的には、先ほどのソフトウェアアーキテクチャの項目内で紹介した要領でimport文から関係性を理解したり、注釈から個々の部品の意義を理解されたらいいと思いますが、いくらか注意されたい点があります。

まず、freezed_entitiesやprovidersについて、build_runnerを使って自動的にコード生成をしています。これはコードの短縮のためです。よって、そのコード短縮のために生成された.freezed.dartや.g.dartは、読む必要はありません。

また、widgetsについてですが、router.dartを除いて、widgetsの中だけはソースコードに注釈をつけておりません。それは、各コンポーネントの仕様を公式に確認しに行ってほしいからです。アレンジアプリにて、追加で必要そうなコンポーネントが出た時にも対処ができることを心掛けていただけたらと存じます。

画面全体の実装あるいはルーティングの設計に関してはscreensディレクトリ内で定義しており、個々の部品はelements及びdialogs等で定義しています。ただし、個々の部品がこれだけであるとは限りません。例えば、ボトムナビゲーションやTabナビゲーション等で、一個のスクリーンに複数の画面を内包したい場合は、fragments等の名前をつけたディレクトリを追加して、個々の画面を分割して設計する必要がありますし、awesome_notifications等のパッケージを導入して通知機能も導入したくなった場合は、notifications等の名前をつけたディレクトリが必要になるかもしれません。

## 不具合について

現状、go_routerのバージョンアップデートによる仕様変更によって、引数の引き渡しを含む画面遷移機能が未だ動作確認できていません。今回のシステムでは、タスク更新画面に飛べていないことになります。

本来はトップ画面でリストビューのタスクをタップしたら内容の変更が可能なのですが、そこの機能をコメントアウトしています。ご不便をおかけします。

以上


